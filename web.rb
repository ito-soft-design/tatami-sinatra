require 'rubygems'
require 'sinatra'
require 'haml'

helpers do
  def protect!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    username = "foo"
    password = "bar"
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [username, password]
  end
end

get '/' do
  haml :index
end

get '/auth' do
  protect!
  haml :auth
end

# アップロードされたファイルを返す
put '/upload' do
  if params[:file]
    content_type params[:file][:type]
    f = params[:file][:tempfile]
    f.read f.size
  end
end

put '/auth_upload' do
  protect!
  if params[:file]
    content_type params[:file][:type]
    f = params[:file][:tempfile]
    f.read f.size
  end
end

__END__
@@index
%html
  %body
    %h1 Tatami (Sinatra)
    %hr
    %p
      This is a sample site for iOS app 
      %a{href:"http://photoshuriken.com"} Photo Shuriken. 
      %a{href:"https://itunes.apple.com/us/app/photo-shuriken/id665902441?l=ja&ls=1&mt=8"} (Available on iTunes)
      %br
      You can upload a photo using Photo Shuriken.
      %br
      Select the setting 'Simple sample'.
      %br
      You can see source code of this site on
      %a{href:"https://github.com/ito-soft-design/tatami-sinatra"} Github.
      %br
      %br
    %form{:action => '/upload', :method => 'POST', :enctype => 'multipart/form-data'}
      %input{:type => 'file',   :name => 'file'}
      %input{:type => 'submit', :value => 'upload'}
      %input{:type => 'hidden', :name => '_method', :value => 'put'}

@@auth
%html
  %body
    %h1 Tatami (Sinatra) with Basic authentication.
    %hr
    %p
      This is a sample site for iOS app 
      %a{href:"http://photoshuriken.com"} Photo Shuriken. 
      %a{href:"https://itunes.apple.com/us/app/photo-shuriken/id665902441?l=ja&ls=1&mt=8"} (Available on iTunes)
      %br
      You can upload a photo using Photo Shuriken.
      %br
      Select the setting 'Basic authentication sample'.
      %br
      You can see source code of this site on
      %a{href:"https://github.com/ito-soft-design/tatami-sinatra"} Github.
      %br
      %br
    %form{:action => '/auth_upload', :method => 'POST', :enctype => 'multipart/form-data'}
      %input{:type => 'file',   :name => 'file'}
      %input{:type => 'submit', :value => 'upload'}
      %input{:type => 'hidden', :name => '_method', :value => 'put'}
