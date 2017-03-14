require 'active_record'


options = {
  adapter: 'postgresql',
  database: 'tododb'
}

ActiveRecord::Base.establish_connection(options)
