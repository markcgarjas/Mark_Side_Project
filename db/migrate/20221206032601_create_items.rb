class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :image
      t.string :name
      t.integer :quantity, default: 0
      t.integer :minimum_bets, default: 0
      t.string :state
      t.integer :batch_count, default: 0
      t.datetime :online_at
      t.datetime :offline_at
      t.datetime :start_at
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
