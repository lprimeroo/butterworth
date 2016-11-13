require 'filter.rb'

describe ButterworthFilter do

	test_image_array = [[1, 2], [3, 4]]
	test_object = ButterworthFilter.new test_image_array
	fft_output = [[(2.5+0.0i), (-0.5+0.0i)], [(-1.0+0.0i), (0.0+0.0i)]]

	describe ".to_frequency_domain" do
		context "given image array" do
			it "returns complex FFTized array" do
				expect(test_object.to_frequency_domain).to eql(fft_output)
			end
		end
	end

	describe ".to_spacial_domain" do
		context "given FFT array" do
			it "returns normal array" do
				expect(test_object.to_spacial_domain(fft_output)).to eql(test_image_array)
			end
		end
	end

	describe ".low_pass_filter" do
		context "given image array" do
			it "returns low pass filtered array" do
				expect(test_object.to_spacial_domain(fft_output)).to eql(test_image_array)
			end
		end
	end

	describe ".high_pass_filter" do
		context "given image array" do
			it "returns high pass filtered array" do
				expect(test_object.to_spacial_domain(fft_output)).to eql(test_image_array)
			end
		end
	end

end