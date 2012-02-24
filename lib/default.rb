# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

def map_preprocessing(item)
  params = item[:map_params]
  data_file = params.delete(:data_file)
  
  converter_params = []
  params.each { |key, value| converter_params << '--'+key.to_s+' "'+value.to_s+'"' }
  
  map_id = Digest::MD5.hexdigest(data_file+converter_params.join)
  map_name = 'jquery-jvectormap-'+params[:name]+'-'+(params[:language] ? params[:language] : 'en')
  output_file_path = 'tmp/'+map_id+'.js'
  
  if !File.exists? output_file_path  
    converter_command = 
        'python '+
        @config[:jvectormap_path]+'/converter/converter.py '+
        data_file+' '+
        output_file_path+' '+
        converter_params.join(' ')

    system(converter_command)
  end
  
  @items << Nanoc3::Item.new(
    File.open(output_file_path, "r").read,
    {},
    "/js/"+map_name+'/'
  )

  item[:js_assets] = ['/js/'+map_name+'.js']
end