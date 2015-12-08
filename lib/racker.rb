require 'erb'
require 'Codebreaker'
require 'json'

class Racker
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when "/" then Rack::Response.new(render("index.html.erb"))
    when "/game" then Rack::Response.new(render("game.html.erb"))
    when "/guess" then logic
    when "/start" then start
    when "/hint" then hint_count
    else Rack::Response.new("404", 404)
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def start
    @request.session[:game] = Codebreaker::Model.new
    Rack::Response.new do |response|
      response.redirect("/game")
    end
  end

  def logic
    Rack::Response.new do |response|
      response.set_cookie("result", session.submit(@request.params["guess"]).join)
      response.redirect("/game")
    end
  end

  def attempts
    session.instance_variable_get(:@guesses)
  end

  def session
    @request.session[:game]
  end

end