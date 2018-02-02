RSpec.describe Snap7::Server do

  it 'initializes' do
    subject
  end


  describe 'native object' do
    it 'is created' do
      # NOTE: Calling original is important, otherwise the next GC will SEGV!
      expect(Snap7).to receive(:srv_create).and_call_original
      subject
    end

    it 'is destroyed' do
      GC.start # minimize garbage objects
      destroyed = []
      allow(Snap7).to receive(:srv_destroy) { |ptrptr| destroyed << ptrptr.read_pointer }

      srv_ptr = Snap7::Server.new.to_ptr # no ref to Snap7::Server object is kept
      GC.start; GC.start # second call is often necessary

      assert_includes destroyed, srv_ptr
    end

    it 'does not crash Snap7.srv_destroy when not stubbed' do
      Snap7::Server.new
      GC.start
    end
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


  describe '#local_port' do
    it 'sets local port' do
      assert_equal  102, subject.local_port
      subject.local_port = 2102
      assert_equal 2102, subject.local_port
    end
  end
end
