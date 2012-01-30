class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :zencoder_output_id
      t.string :status
      t.string :original_file

      t.timestamps
    end
  end
end
