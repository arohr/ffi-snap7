RSpec.describe Snap7::Server do

  it 'initializes' do
    subject
  end

  it 'creates native object' do
    expect(Snap7).to receive(:srv_create) { FFI::MemoryPointer.new :pointer }
    subject
  end

  describe '#start' do
    it 'binds to default port' do
      expect(Snap7).to receive(:srv_start).with(FFI::Pointer) { 0 }
      subject.start
    end

    it 'checks for error' do
      expect(Snap7).to receive(:srv_start) { 1 }
      expect(Snap7).to receive(:srv_error_text).with(1, FFI::MemoryPointer, Integer) do |_, ptr, len|
        assert_equal len, ptr.size
        ptr.write_string 'error: foo'
        0
      end

      assert_raises do
        subject.start
      end
    end
  end

  describe '#stop' do
    it 'stops' do
      expect(Snap7).to receive(:srv_stop) { 0 }
      subject.stop
    end
  end
end

