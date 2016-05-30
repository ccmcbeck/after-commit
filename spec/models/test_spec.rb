require 'rails_helper'

RSpec::Matchers.define :have_change_of do |attr|
  match do |actual|
    actual.changes.key?(attr.to_s)
  end
end

RSpec::Matchers.define :have_previous_change_of do |attr|
  match do |actual|
    actual.previous_changes.key?(attr.to_s)
  end
end

RSpec::Matchers.define :have_saved_change_of do |attr|
  match do |actual|
    actual.saved_changes.key?(attr.to_s)
  end
end

RSpec.describe Test, type: :model do

  let!(:now) { Time.now }
  let(:params_one) { { number: 1, title: "1", text: "1", test_at: now + 1.day }}
  let(:params_two) { { number: 2, title: "2", text: "2", test_at: now + 2.days }}

  subject { test }

  shared_examples_for :changes do
    it { is_expected.to have_change_of :number }
    it { is_expected.to have_change_of :title }
    it { is_expected.to have_change_of :text }
    it { is_expected.to have_change_of :test_at }
  end

  shared_examples_for :no_changes do
    it { is_expected.not_to have_change_of :number }
    it { is_expected.not_to have_change_of :title }
    it { is_expected.not_to have_change_of :text }
    it { is_expected.not_to have_change_of :test_at }
  end

  shared_examples_for :previous_changes do
    it { is_expected.to have_previous_change_of :number }
    it { is_expected.to have_previous_change_of :title }
    it { is_expected.to have_previous_change_of :text }
    it { is_expected.to have_previous_change_of :test_at }
  end

  shared_examples_for :no_previous_changes do
    it { is_expected.not_to have_previous_change_of :number }
    it { is_expected.not_to have_previous_change_of :title }
    it { is_expected.not_to have_previous_change_of :text }
    it { is_expected.not_to have_previous_change_of :test_at }
  end

  shared_examples_for :saved_changes do
    it { is_expected.to have_saved_change_of :number }
    it { is_expected.to have_saved_change_of :title }
    it { is_expected.to have_saved_change_of :text }
    it { is_expected.to have_saved_change_of :test_at }
  end

  shared_examples_for :no_saved_changes do
    it { is_expected.not_to have_saved_change_of :number }
    it { is_expected.not_to have_saved_change_of :title }
    it { is_expected.not_to have_saved_change_of :text }
    it { is_expected.not_to have_saved_change_of :test_at }
  end

  describe 'when new with no attr' do
    let!(:test) { Test.new }
    it_behaves_like :no_changes
    it_behaves_like :no_previous_changes
    it_behaves_like :no_saved_changes
  end

  describe 'when new with initial attr' do
    let!(:test) { Test.new params_one }
    it_behaves_like :changes
    it_behaves_like :no_previous_changes
    it_behaves_like :no_saved_changes
  end

  describe 'when create with no attr' do
    let!(:test) { Test.create }
    it_behaves_like :no_changes
    it_behaves_like :no_previous_changes
    it_behaves_like :no_saved_changes
  end

  describe 'when create with initial attr' do
    let!(:test) { Test.create params_one }
    it_behaves_like :no_changes
    it_behaves_like :previous_changes
    it_behaves_like :saved_changes
  end

  describe 'when record exists' do
    before { Test.create params_one }
    let!(:test) { Test.first }

    context 'and saved again to new value' do
      before { test.update params_two }
      it_behaves_like :no_changes
      it_behaves_like :previous_changes
      it_behaves_like :saved_changes

      context 'and saved again to original value' do
        before { test.update params_one }
        it_behaves_like :no_changes
        it_behaves_like :previous_changes
        it_behaves_like :no_saved_changes
        it 'filters changes that remain the same' do
          expect(test.saved_changes_unfiltered["number"]).to eq [1,1]
        end
      end
    end

    context 'in a successful transaction' do
      before do
        test.transaction do
          test.update params_two
          test.update params_one
        end
      end
      it_behaves_like :no_changes
      it_behaves_like :previous_changes
      it_behaves_like :no_saved_changes
    end

    context 'in a rolled back transaction' do

      context 'it looks like success' do
        before do
          begin
            test.transaction do
              test.update params_two
              raise StandardError
            end
          rescue StandardError
          end
        end
        it_behaves_like :no_changes
        it_behaves_like :previous_changes
        it_behaves_like :saved_changes
      end

      context 'unless you reset the saved changes' do
        before do
          begin
            test.transaction do
              test.update params_two
              raise StandardError
            end
          rescue StandardError
            test.reset_saved_changes
          end
        end
        it_behaves_like :no_changes
        it_behaves_like :previous_changes
        it_behaves_like :no_saved_changes
      end
    end
  end
end
