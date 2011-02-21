ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  {
    :adapter => 'postgresql',
    :database => 'phat_pgsearch',
    :encoding => 'utf-8',
    :password => 'devel',
    :host => 'localhost',
    :username => 'pgadmin',
    :min_messages => 'WARNING'
  }
)

ActiveRecord::Schema.define(:version => 0) do
  create_table :sample_headers, :force => true do |t|
    t.string :title
    t.tsvector :tsv
  end
  create_table :sample_items, :force => true do |t|
    t.integer :sample_header_id
    t.text :content
    t.tsvector :tsv
    t.tsvector :tsv_full
  end
  create_table :sample_comments, :force => true do |t|
    t.integer :sample_item_id
    t.text :comment
    t.tsvector :tsv
  end

  add_gin_index :sample_headers, :tsv, :gin => true
  add_gin_index :sample_items, :tsv, :gin => true
  add_gist_index :sample_comments, :tsv, :gist => true
end

class SampleHeader < ActiveRecord::Base
  has_many :sample_items

  pgsearch_index :tsv, :catalog => :german do
    field :title, :weight => :a
  end

end
class SampleItem < ActiveRecord::Base
  has_many :sample_comments
  belongs_to :sample_header

  pgsearch_index :tsv, :catalog => :english do
    field :content
  end

  pgsearch_index :tsv_full, :catalog => :german do
    field :title, :weight => :a
    field :content, :weight => :b
    field :comment_texts, :weight => :d
  end

  def title
    sample_header.title
  end

  def comment_texts
    sample_comments.collect{ |comment| comment.comment }.join('')
  end

end
class SampleComment < ActiveRecord::Base
  belongs_to :sample_item
end