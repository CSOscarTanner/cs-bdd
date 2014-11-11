def create_feature_file name, platform = nil

  # options used to generate the file in the template function
  opts = {:name => camelize(name)}

  # If platform is not nil than the feature is OS dependent
  file_path = ""
  if platform.nil?
    file_path = File.join( FileUtils.pwd, "features", "#{name.downcase}.feature" )
    opts[:platform] = ""
  else
    file_path = File.join( FileUtils.pwd, "features", platform.downcase, "features", "#{name.downcase}.feature" )
    opts[:platform] = platform
  end

  # Thor creates a file based on the templates/feature.tt template
  template( "feature", file_path, opts )
end

def create_steps_file name, platform = nil

  # options used to generate the file in the template function
  opts = {:name => camelize(name)}  

  # If platform is not nil than the step is OS dependent
  file_path = nil
  if platform.nil?
    file_path = File.join( FileUtils.pwd, "features", "step_definitions", "#{name.downcase}_steps.rb" )
    opts[:platform] = ""
  else
    file_path = File.join( FileUtils.pwd, "features", platform.downcase, "step_definitions", "#{name.downcase}_steps.rb" )
    opts[:platform] = platform
  end

  # Thor creates a file based on the templates/steps.tt template
  template( "steps", file_path, opts )
end

def create_screen_file name, platform

  # options used to generate the file in the template function
  opts = {:name => camelize(name), :platform => platform}

  # Thor creates a file based on the templates/screen.tt template
  template( "screen", File.join( FileUtils.pwd, "features", platform.downcase, "screens", "#{name.downcase}_screen.rb"), opts )
end

def camelize string

  camelized = ""

  string.split("_").each do |s|
    camelized = camelized + s.capitalize
  end

  return camelized
end