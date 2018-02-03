RSpec.describe Snap7::Client do

  it 'initializes' do
    subject
  end


  describe 'native object' do
    it 'is created' do
      # NOTE: Calling original is important, otherwise the next GC will SEGV!
      expect(Snap7).to receive(:cli_create).and_call_original
      subject
    end

    it 'is destroyed' do
      GC.start # minimize garbage objects
      destroyed = []
      allow(Snap7).to receive(:cli_destroy) { |ptrptr| destroyed << ptrptr.read_pointer }

      cli_ptr = Snap7::Client.new.to_ptr # no ref to Snap7::Client object is kept
      GC.start; GC.start # second call is often necessary

      assert_includes destroyed, cli_ptr
    end
  end


  describe '#connected?' do
    it 'initializes disconnected' do
      refute subject.connected?
    end
  end


  describe '#connect' do
    let(:address) { double }
    let(:rack) { double }
    let(:slot) { double }

    it 'connects to default port' do
      expect(Snap7).to receive(:cli_connect_to).with(FFI::Pointer, address, rack, slot) { 0 }
      subject.connect address, rack, slot
    end

    it 'marks as connected' do
      allow(Snap7).to receive(:cli_connect_to){ 0 }
      subject.connect address, rack, slot

      assert subject.connected?
    end

    it 'checks for error' do
      expect(Snap7).to receive(:cli_connect_to) { 1 }
      expect(Snap7).to receive(:cli_error_text).with(1, FFI::MemoryPointer, Integer) do |_, ptr, len|
        assert_equal len, ptr.size
        ptr.write_string 'error: foo'
        0
      end

      assert_raises do
        subject.connect address, rack, slot
      end
    end
  end


  describe '#disconnect' do
    it 'disconnects' do
      expect(Snap7).to receive(:cli_disconnect)
      subject.disconnect
    end

    it 'marks as disconnected' do
      allow(Snap7).to receive(:cli_connect_to){ 0 }
      subject.connect double, double, double
      assert subject.connected?

      allow(Snap7).to receive(:cli_disconnect)
      subject.disconnect
      refute subject.connected?
    end
  end


  describe '#remote_port' do
    it 'sets remote port' do
      assert_equal  102, subject.remote_port
      subject.remote_port = 2102
      assert_equal 2102, subject.remote_port
    end
  end
end
