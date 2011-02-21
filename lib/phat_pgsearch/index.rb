module PhatPgsearch
  class Index

    # field to index with options
    # field :test, :weight => :a
    def field(*args)
      options = args.extract_options!

    end
  end
end