# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe PhatPgsearch::ActiveRecord do
  describe SampleHeader do
    describe "#save" do
      before do
        @sample_header = SampleHeader.new(:title => "Some test title")
      end

      subject { @sample_header }

      it "should have build index after save" do
        subject.save
        subject.tsv.should_not be_nil
      end
    end
  end

  describe SampleItem do
    describe "#save" do
      before do
        @sample_header = SampleHeader.new(:title => "Some test title")
        @sample_item = @sample_header.sample_items.build(:content => 'noch so ein süßer test mit sonder zeichen')
        @sample_item.sample_comments.build(:comment => 'das ist ein kommentar')
        @sample_item.sample_comments.build(:comment => 'das ist ein weiterer kommentar')
        @sample_header.save
      end

      subject { @sample_item }

      it "should have build index after save" do
        subject.tsv.should_not be_nil
        subject.tsv_full.should_not be_nil
      end
    end
  end

  context "sample archive" do
    before :all do
      @sample_header = SampleHeader.new(:title => "Some test title")
      @sample_item = @sample_header.sample_items.build(:content => 'noch so ein süßer test mit sonder zeichen')
      @sample_item.sample_comments.build(:comment => 'das ist ein kommentar')
      @sample_item.sample_comments.build(:comment => 'das ist ein weiterer kommentar')
      @sample_header.save
    end

    describe "#pgsearch with table-field in string" do
      before { @pgsearch = SampleItem.pgsearch("sample_items.tsv", 'kommentar') }
      subject { @pgsearch }
      it "should do something" do
        subject.to_a
      end
    end

    describe "#pgsearch with field in string" do
      before { @pgsearch = SampleItem.pgsearch("tsv", 'kommentar') }
      subject { @pgsearch }
      it "should do something" do
        subject.to_a
      end
    end

    describe SampleItem do
      describe "#pgsearch :tsv, 'kommentar'" do
        before { @pgsearch = SampleItem.pgsearch(:tsv, 'kommentar') }
        subject { @pgsearch }
        it "should do something" do
          subject.to_a
        end

      end
      describe "#pgsearch :tsv_full, 'kommentar'" do
        before { @pgsearch = SampleItem.pgsearch(:tsv_full, 'kommentar') }
        subject { @pgsearch }
        it "should do something" do
          subject.to_a
        end

      end
      describe "#pgsearch :tsv_full, 'kommentar', :catalog => :german" do
        before { @pgsearch = SampleItem.pgsearch(:tsv_full, 'kommentar', :catalog => :german) }
        subject { @pgsearch }
        it "should do something" do
          subject.to_a
        end

      end
      describe "#pgsearch :tsv_full, 'kommentar', :rank => false" do
        before { @pgsearch = SampleItem.pgsearch(:tsv_full, 'kommentar', :rank => false).select("sample_items.*, #{SampleItem.pgsearch_query(:tsv_full, 'kommentar')} AS rank").order(:rank) }
        subject { @pgsearch }
        it "should do something" do
          subject.to_a
        end

      end
    end

  end

end
