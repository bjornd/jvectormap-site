# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

require 'json'

def map_preprocessing(item)
  item[:map_params_variants] ||= [Hash.new]
  params = item[:map_params]
  params[:projection] ||= 'mill'
  params[:language] ||= 'en'

  item[:js_assets] = []

  item[:map_params_variants].each_index do |index|
    item[:map_params_variants][index] = item[:map_params].merge(item[:map_params_variants][index])
    variant_params = item[:map_params_variants][index]

    converter_params = []
    if variant_params[:codes_file]
      variant_params[:codes_file] = @config[:maps_path] + '/codes/' + variant_params[:codes_file]
    end
    variant_params[:input_file] =  @config[:maps_path]+'/'+variant_params[:input_file]
    if @config[:maps_default_encoding] && !variant_params[:input_file_encoding]
      variant_params[:input_file_encoding] = @config[:maps_default_encoding]
    end

    map_id = Digest::MD5.hexdigest(variant_params.to_json)
    map_name = 'jquery-jvectormap-'+variant_params[:name]+'-'+variant_params[:projection]+'-'+variant_params[:language]
    output_file_path = 'tmp/'+map_id+'.js'
    variant_params['output_file'] = output_file_path
    converter_params = variant_params.to_json

    if !File.exists? output_file_path
      converter_command =
          'echo \''+converter_params+'\' | '+
          'python '+
          'external/jvectormap/converter/converter.py '
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

def generate_doc
  hash = get_jvectormap_commit_hash
  FileUtils.mkpath('tmp/doc') if !File.exists?('tmp/doc')
  tmpDir = 'tmp/doc/'+hash+'/'
  if !File.exists?(tmpDir)
    `external/jsdoc/jsdoc -t ../jsdoc_template/ -d #{tmpDir} external/jvectormap/src/`
  end

  Dir.foreach(tmpDir) do |fname|
    next if !['jvm-dataseries.html', 'jvm-map.html', 'jvm-proj.html', 'jvm-marker.html', 'jvm-region.html'].index(fname)
    itemTile, itemText = File.open(tmpDir + fname, "rb").read.split("\n", 2)

    @items << Nanoc3::Item.new(
      itemText,
      {title: itemTile, submenu: true},
      "/documentation/javascript-api-v1/"+File.basename(tmpDir + fname, '.html')+"/"
    )
  end
end

def build_jvectormap
  hash = get_jvectormap_commit_hash
  FileUtils.mkpath('tmp/jvectormap') if !File.exists?('tmp/jvectormap')
  tmpFile = 'tmp/jvectormap/'+hash
  if !File.exists?(tmpFile)
    `external/jvectormap/build.sh #{tmpFile}`
  end
  js_file_name = "jquery-jvectormap-#{@config[:jvectormap_version]}.min"
  @items << Nanoc3::Item.new(
    File.open(tmpFile, "rb").read,
    {},
    "/js/#{js_file_name}/"
  )
  css_file_name = "jquery-jvectormap-#{@config[:jvectormap_version]}"
  @items << Nanoc3::Item.new(
    File.open("external/jvectormap/jquery-jvectormap.css", "rb").read,
    {},
    "/css/#{css_file_name}/"
  )

  FileUtils.mkpath('tmp/jvectormap-zip') if !File.exists?('tmp/jvectormap-zip')
  FileUtils.copy_file(tmpFile, "tmp/jvectormap-zip/#{js_file_name}.js")
  FileUtils.copy_file('external/jvectormap/jquery-jvectormap.css', "tmp/jvectormap-zip/#{css_file_name}.css")
  `cd tmp/jvectormap-zip; zip jquery-jvectormap-#{@config[:jvectormap_version]}.zip *.css *.js`
  @items << Nanoc3::Item.new(
    File.open("tmp/jvectormap-zip/jquery-jvectormap-#{@config[:jvectormap_version]}.zip", "rb").read,
    {},
    "/binary/jquery-jvectormap-#{@config[:jvectormap_version]}/"
  )
end

def get_jvectormap_commit_hash
  return `git submodule | grep jvectormap`.strip.split(' ').shift
end

#Import several lines from another file.
def import_code(link)
  from_label = '//'+link+'_start'
  to_label = '//'+link+'_end'
  from = @item.raw_content.index(from_label)+from_label.length
  to = @item.raw_content.index(to_label)-1
  result = @item.raw_content[from..to]
  indent_length = result.match(/^\n +/m)[0].length-1
  return result.gsub(/\n {#{indent_length}}/, "\n")[1..-1]
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