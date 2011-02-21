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

    describe SampleItem do
      describe "#pgsearch :tsv, 'kommentar'" do
        before { @pgsearch = SampleItem.pgsearch(:tsv, 'kommentar') }
        subject { @pgsearch }
        it "shoud do something" do

        end

      end
      describe "#pgsearch :tsv_full, 'kommentar'" do
        before { @pgsearch = SampleItem.pgsearch(:tsv_full, 'kommentar') }
        subject { @pgsearch }
        it "shoud do something" do
          
        end

      end
    end

  end

end
