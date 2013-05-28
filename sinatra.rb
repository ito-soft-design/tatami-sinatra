require 'rubygems'
require 'sinatra'
require 'haml'

=begin
use Rack::Auth::Basic do |username, password|
  username =~ /(foo|var)/
end
=end

get '/' do
    haml :index
end

# アップロードされたファイルを返す
put '/upload' do
p params
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
    %form{:action => '/upload', :method => 'POST', :enctype => 'multipart/form-data'}
      %input{:type => 'file',   :name => 'file'}
      %input{:type => 'submit', :value => 'upload'}
      %input{:type => 'hidden', :name => '_method', :value => 'put'}

