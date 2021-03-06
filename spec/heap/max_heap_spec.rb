#!/usr/bin/env ruby

require 'spec_helper'
require 'heap'

describe MaxHeap do
  let(:heap) { described_class.new }

  describe '#insert' do
    it 'inserts an element into the heap' do
      heap.insert(33)
      expect(heap.max).to eq(33)
    end
  end

  describe '#max' do
    it 'returns the element at the root' do
      heap.insert(33)
      heap.insert(94)
      heap.insert(18)

      expect(heap.max).to eq(94)
    end
  end

  describe '#remove_max' do
    it 'removes the element at the root' do
      heap.insert(33)
      heap.insert(94)
      heap.insert(18)

      expect(heap.remove_max).to eq(94)
      expect(heap.max).to eq(33)
    end
  end

  describe '#new' do
    context 'given an array' do
      it 'creates a heap with all elements' do
        heap = described_class.new([94, 33, 48, 18, 82])
        expect(heap.max).to eq(94)
      end
    end

    context 'given multiple argument' do
      it 'creates a heap with all arguments' do
        heap = described_class.new(94, 33, 48, 18, 82)
        expect(heap.max).to eq(94)
      end
    end

    context 'given a single argument' do
      it 'creates a heap with it' do
        heap = described_class.new(48)
        expect(heap.max).to eq(48)
      end

      context 'which is nil' do
        it 'creates a heap with it' do
          heap = described_class.new(nil)
          expect(heap.max).to eq(nil)
        end
      end
    end
  end
end
