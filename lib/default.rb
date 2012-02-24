# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

def map_preprocessing(item)
  params = item[:map_params]
  data_file = params.delete(:data_file)
  output_file = 'tmp/jquery-jvectormap-'+params[:name]+'-'+(params[:language] ? params[:language] : 'en')+'.js'
  
  converter_params = []
  params.each { |key, value| converter_params << '--'+key.to_s+' "'+value.to_s+'"' }
  
  system(
    'python '+
    @config[:jvectormap_path]+'/converter/converter.py '+
    data_file+' '+
    output_file+' '+
    converter_params.join(' ')
  )
end