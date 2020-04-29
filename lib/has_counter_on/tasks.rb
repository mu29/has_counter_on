namespace :has_counter_on do
  desc 'Setup has_counter_on environment'
  task :setup do
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    ar_migration_path = ActiveRecord::Schema.migrations_paths.first
    migration_path = "#{ar_migration_path}/#{timestamp}_create_counters.rb"

    ar_version = "#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}"
    migration_content = %Q{
class CreateCounters < ActiveRecord::Migration[#{ar_version}]
  def change
    create_table :counters do |t|
      t.string :countable_type, limit: 64
      t.integer :countable_id, unsigned: true
      t.string :countable_name
      t.integer :value
    end

    add_index :counters, [:countable_id, :countable_type, :countable_name], name: :index_counters_on_countable_id_type_name
  end
end
    }.strip

    system("touch #{migration_path}")
    system("echo '#{migration_content}' >> #{migration_path}")
  end
end
