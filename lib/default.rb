# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

def map_preprocessing(item)
  item[:map_params_variants] ||= [Hash.new]
  params = item[:map_params]
  params[:projection] ||= 'mill'
  params[:language] ||= 'en'
  data_file = @config[:maps_path]+'/'+params.delete(:data_file)

  item[:js_assets] = []

  item[:map_params_variants].each_index do |index|
    item[:map_params_variants][index] = item[:map_params].merge(item[:map_params_variants][index])
    variant_params = item[:map_params_variants][index]

    converter_params = []
    if variant_params[:codes_file]
      variant_params[:codes_file] = @config[:maps_path] + '/codes/' + variant_params[:codes_file]
    end
    variant_params.each { |key, value| converter_params << '--'+key.to_s+" '"+value.to_s+"'" }

    map_id = Digest::MD5.hexdigest(data_file+converter_params.join)
    map_name = 'jquery-jvectormap-'+variant_params[:name]+'-'+variant_params[:projection]+'-'+variant_params[:language]
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

    item[:map_params_variants][index][:download_link] = '/js/'+map_name+'.js'
    item[:map_params_variants][index][:file_size] = File.size output_file_path
    item[:map_params_variants][index][:name] = variant_params[:name]+'_'+variant_params[:projection]+'_'+variant_params[:language]

    item[:js_assets] << '/js/'+map_name+'.js'
  end
end

def jvectormap_init
  `cd external/jvectormap; git checkout develop`
  `external/jvectormap/build.sh content/js/jquery-jvectormap.js`
end

#converts number of bytes to human-readable format, code is from
#http://www.ruby-forum.com/topic/92075
def numer_to_human_size(size)
  prefix = %W(TB GB MB KB B)
  i = prefix.length - 1
  while size > 512 && i > 0
    size /= 1024
    i -= 1
  end
  ((size > 9 || size.modulo(1) < 0.1 ? '%d' : '%.1f') % size) + ' ' + prefix[i]
end