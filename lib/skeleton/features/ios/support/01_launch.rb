########################################
#                                      #
#       Important Note                 #
#                                      #
#   When running calabash-ios tests at #
#   www.xamarin.com/test-cloud         #
#   the  methods invoked by            #
#   CalabashLauncher are overriden.    #
#   It will automatically ensure       #
#   running on device, installing apps #
#   etc.                               #
#                                      #
########################################

require 'calabash-cucumber/launcher'

# APP_BUNDLE_PATH = "~/Library/Developer/Xcode/DerivedData/??/Build/Products/Calabash-iphonesimulator/??.app"
# You may uncomment the above to overwrite the APP_BUNDLE_PATH
# However the recommended approach is to let Calabash find the app itself
# or set the environment variable APP_BUNDLE_PATH

Before('@reinstall') do |scenario|
  reinstall_app
end

Before do |scenario|
  
  # If the scenario is outline, to get the feature title we have to access a different attribute of the variable scenario,
  # so this function changes the value of the scenario variable so we don't have to do this on the verification step below 
  @scenario_is_outline = (scenario.class == Cucumber::Ast::OutlineTable::ExampleRow)
  if @scenario_is_outline 
    scenario = scenario.scenario_outline 
  end
  # Looks if is a new feature that will be executed
  if ENV['FEATURE_NAME'] != scenario.feature.title # ENV['FEATURE_NAME'] is just an aux created to store the feature name
    reinstall_app # always reinstall the app before a the execution of a new feature
    ENV['FEATURE_NAME'] = scenario.feature.title
  end 

  @calabash_launcher = Calabash::Cucumber::Launcher.new
  unless @calabash_launcher.calabash_no_launch?
    @calabash_launcher.relaunch
    @calabash_launcher.calabash_notify(self)
  end

end

After do |scenario|
  unless @calabash_launcher.calabash_no_stop?
    calabash_exit
    if @calabash_launcher.active?
      @calabash_launcher.stop
    end
  end
end

at_exit do
  launcher = Calabash::Cucumber::Launcher.new
  if launcher.simulator_target?
    launcher.simulator_launcher.stop unless launcher.calabash_no_stop?
  end
end

# Install or reinstall the app on the device
def reinstall_app

  system( "echo 'Installing the app...'" )  

  # Trying to reinstall the app
  success = system "ios-deploy -r -b #{ENV['APP_BUNDLE_PATH']} -i #{ENV['DEVICE_TARGET']} -t 5 > /dev/null"

  # If the app is not installed the above command will throw an error
  # So we just install the app
  if !success
    success = system "ios-deploy -b #{ENV['APP_BUNDLE_PATH']} -i #{ENV['DEVICE_TARGET']} -t 5 > /dev/null"
    if !success # If there is any error raises an exception
      raise 'Error. Could not install the app.'
    end
  end

  system( "echo 'Installed.'" )

  sleep(3) # Gives to the iphone a time to finish the installation of the app
end
