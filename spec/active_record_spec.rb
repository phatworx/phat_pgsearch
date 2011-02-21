require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe PhatPgsearch::ActiveRecord do
  describe SampleHeader do
    describe "#index :index1 with catalog german" do
      before do
        SampleHeader.index :index1 do

        end
      end
    end
  end
end
