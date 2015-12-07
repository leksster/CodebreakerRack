require './lib/racker'
use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :expire_after => 2592000,
                           :secret => 'secretus_invokus'

use Rack::Static, :urls => ["/stylesheets", "/js"], :root => "public"
run Racker