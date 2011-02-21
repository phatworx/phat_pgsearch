# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe PhatPgsearch::ActiveRecord do
  describe SampleHeader do
    describe "#index :index1 with catalog german" do
      before do
        @sample_header = SampleHeader.new(:title => "Some test title")
      end

      subject { @sample_header }

      it "should have build index after save" do
        #p subject.inspect
        subject.save
        p subject.tsv
        subject.tsv.should_not be_nil
      end


    end
  end


  describe SampleHeader do
    describe "dfgdgdfg" do
      before do
        @sample_header = SampleHeader.new(:title => "Some test title")
        @sample_item = @sample_header.sample_items.build(:content => 'noch so ein süßer test mit sonder zeichen')
        @sample_header.save
      end

      subject { @sample_item }

      it "should have build index after save" do
        subject.tsv_full.should_not be_nil
      end


    end
  end

end
