if ENV['COVERAGE'] == 'yes'
  SimpleCov.start 'rails' do
    add_filter "/spec/"
    add_filter "/vendor/"
    add_filter "/.bundle/"
  end
end

