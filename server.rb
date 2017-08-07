#!/usr/bin/env ruby

require 'bundler/setup'

require 'active_support'
require 'active_support/core_ext'
require 'faker'
require 'sinatra'

helpers do
  def faker_method
    type = params[:type].try(:classify)
    name = params[:name].try(:underscore)

    halt 400 unless type.present? && name.present?

    Faker.const_get(type).method(name)
  end

  def faker_args
    params.except(:type, :name).keys.map(&:to_s).map do |key|
      case
      when 'true' == key;                       true
      when 'false' == key;                      false
      when key.match?(/^[0-9]+(?:\.[0-9]+)?$/); key.to_f
      else                                      key
      end
    end
  end
end


get '/faker/:type/:name' do
  content_type :json

  faker_method.call(*faker_args).to_json
end

get '/faker/:type/unique/:name' do
  content_type :json

  faker_method.call(*faker_args).to_json
end
