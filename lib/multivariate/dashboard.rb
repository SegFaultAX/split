require 'sinatra/base'
require 'multivariate'

module Multivariate
  class Dashboard < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/dashboard/views"
    set :public, "#{dir}/dashboard/public"
    set :static, true

    helpers do
      def url(*path_parts)
        [ path_prefix, path_parts ].join("/").squeeze('/')
      end

      def path_prefix
        request.env['SCRIPT_NAME']
      end
    end

    get '/' do
      @experiments = Multivariate::Experiment.all
      erb :index
    end

    post '/:experiment' do
      @experiment = Multivariate::Experiment.find(params[:experiment])
      @alternative = Multivariate::Alternative.find(params[:alternative], params[:experiment])
      @experiment.winner = @alternative.name
      @experiment.save
      redirect url('/')
    end
  end
end