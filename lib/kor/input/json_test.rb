require 'kor/input/json'

module KorInputJsonTest
  def test_initialize(t)
    _, err = go { Kor::Input::Json.new }
    unless ArgumentError === err
      t.error("expect raise an ArgumentError got #{err.class}:#{err}")
    end

    _, err = go { Kor::Input::Json.new(nil) }
    if err != nil
      t.error("expect not raise an error got #{err.class}:#{err}")
    end
  end

  TEST_DATA = [
    -> {
      io = StringIO.new(<<-JSON)
{"foo": 100, "bar": 200}
{"bar": 500, "baz": 600}
JSON
      Kor::Input::Json.new(io)
    },
    -> {
      io = StringIO.new('[{"foo": 100, "bar": 200}, {"bar": 500, "baz": 600}]')
      json = Kor::Input::Json.new(io)
      opt = OptionParser.new
      json.parse(opt)
      opt.parse(["--single"])
      json
    },
  ]

  def test_head(t)
    TEST_DATA.each do |pr|
      json = pr.call
      head = json.head
      expect = %w(foo bar baz)
      if head != expect
        t.error("expect #{expect} got #{head}")
      end
    end
  end

  def test_gets(t)
    TEST_DATA.each do |pr|
      json = pr.call
      json.head

      body = json.gets
      expect = [100, 200, nil]
      if body != expect
        t.error("expect #{expect} got #{body}")
      end

      body = json.gets
      expect = [nil, 500, 600]
      if body != expect
        t.error("expect #{expect} got #{body}")
      end

      10.times do
        body = json.gets
        if body != nil
          t.error("expect nil got #{body}")
        end
      end
    end
  end

  private

  def go
    [yield, nil]
  rescue Exception => err
    [nil, err]
  end
end
