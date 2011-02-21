ActiveRecord::Base.establish_connection({
  :adapter => 'postgresql',
  :database => 'phat_pgsearch',
  :encoding => 'utf-8',
  :password =>  'devel',
  :host => 'localhost',
  :username => 'pgadmin',
  :min_messages => 'WARNING'
})

ActiveRecord::Schema.define(:version => 0) do
  create_table :sample_headers, :force => true do |t|
    t.column :title, :string
  end
  create_table :sample_items, :force => true do |t|
    t.column   :sample_header_id, :integer
    t.column :content, :text
  end
  create_table :sample_comments, :force => true do |t|
    t.column :sample_item_id, :integer
    t.column :comment, :text
  end
end

class SampleHeader < ActiveRecord::Base
  has_many :sample_items
end
class SampleItem < ActiveRecord::Base
  has_many :sample_comments
  belongs_to :sample_header
end
class SampleComment < ActiveRecord::Base
  belongs_to :sample_item
end