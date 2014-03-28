require 'pry'

class Person < ActiveRecord::Base

  belongs_to :father, class_name: "Person", foreign_key: "father_id"
  belongs_to :mother, class_name: "Person", foreign_key: "mother_id"

  validates :name, :presence => true

  # after_save :make_marriage_reciprocal

  def children
    children = []
    children << Person.where(:mother_id => self.id)
    children << Person.where(:father_id => self.id)
    children.flatten!
    children
  end

  def aunts_uncles
    aunts_uncles = []
    aunts_uncles << self.mother.siblings
    aunts_uncles << self.father.siblings
    aunts_uncles.flatten!
    aunts_uncles
  end

  def cousins
    cousins = []
    self.mother.siblings.each do |sibling|
      sibling.children.each do |cousin|
        cousins << cousin
      end
    end
    self.father.siblings.each do |sibling|
      sibling.children.each do |cousin|
        cousins << cousin
      end
    end
    cousins.flatten!
    cousins
  end

  def siblings
    sibs = self.mother.children.reject! { |people| people == self }
    sibs
  end

  def grandchildren
    grandchildren = []
    if self.children.nil?
      nil
    else
      self.children.each do |child|
        if child.children.nil?
          nil
        else
          grandchildren << child.children
        end
      end
      grandchildren.flatten!
    end
    grandchildren
  end

  def grandparents
    grandparents = []
    father = Person.where(:id => self.father_id).first
    mother = Person.where(:id => self.mother_id).first
    grandparents << Person.find(mother.mother.id)
    grandparents << Person.find(mother.father.id)
    grandparents << Person.find(father.mother.id)
    grandparents << Person.find(father.father.id)
    grandparents.flatten!
    grandparents
  end

  def spouse
    if spouse_id.nil?
      nil
    else
      Person.find(spouse_id)
    end
  end

  def divorce
    self.update(:spouse_id => nil)
  end
end
# private

#   def make_marriage_reciprocal
#     if spouse_id_changed?
#       spouse.update(:spouse_id => id)
#     end
#   end
# end
