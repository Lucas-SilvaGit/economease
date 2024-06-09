class ChangeUsersIdToUuid < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :uuid, :uuid, default: "gen_random_uuid()", null: false

    User.find_each do |user|
      user.update_column(:uuid, SecureRandom.uuid)
    end

    remove_column :users, :id

    rename_column :users, :uuid, :id

    execute <<-SQL
      ALTER TABLE users ADD PRIMARY KEY (id);
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end