require 'spec_helper'

I18n.enforce_available_locales = false

describe Person do
  it { should belong_to :father }
  it { should belong_to :mother }
  it { should validate_presence_of :name }

  context '#spouse' do
    it 'returns the person with their spouse_id' do
      earl = Person.create(:name => 'Earl')
      steve = Person.create(:name => 'Steve')
      steve.update(:spouse_id => earl.id)
      steve.spouse.should eq earl
    end

    it "is nil if they aren't married" do
      earl = Person.create(:name => 'Earl')
      earl.spouse.should be_nil
    end
  end

  it "updates the spouse's id when it's spouse_id is changed" do
    earl = Person.create(:name => 'Earl')
    steve = Person.create(:name => 'Steve')
    steve.update(:spouse_id => earl.id)
    earl.reload
    earl.spouse_id.should eq steve.id
  end

  describe '#grandparents' do
    it 'displays the persons grandparents' do
      karl = Person.create(:name => 'Karl')
      #karl parents
      earl = Person.create(:name => 'Earl')
      mary = Person.create(:name => 'Mary')
      #earl parents
      steve = Person.create(:name => 'Steve')
      lois = Person.create(:name => 'Lois')
      #mary parents
      gary = Person.create(:name => 'Gary')
      beth = Person.create(:name => 'Beth')

      karl.update({:father_id => earl.id, :mother_id => mary.id})
      #karl parents
      earl.update({:spouse_id => mary.id, :father_id => steve.id, :mother_id => lois.id})
      mary.update(:spouse_id => earl.id, :father_id => gary.id, :mother_id => beth.id)
      #earl parents
      steve.update(:spouse_id => lois.id)
      lois.update(:spouse_id => steve.id)
      #mary parents
      gary.update(:spouse_id => beth.id)
      beth.update(:spouse_id => gary.id)

      karl.grandparents.should eq [beth, gary, lois, steve]
    end
  end
  describe '#grandchildren' do
    it 'displays the persons grandchildren' do
      karl = Person.create(:name => 'Karl')
      #karl parents
      earl = Person.create(:name => 'Earl')
      mary = Person.create(:name => 'Mary')
      #earl parents
      steve = Person.create(:name => 'Steve')
      lois = Person.create(:name => 'Lois')
      #mary parents
      gary = Person.create(:name => 'Gary')
      beth = Person.create(:name => 'Beth')

      karl.update({:father_id => earl.id, :mother_id => mary.id})
      #karl parents
      earl.update({:spouse_id => mary.id, :father_id => steve.id, :mother_id => lois.id})
      mary.update(:spouse_id => earl.id, :father_id => gary.id, :mother_id => beth.id)
      #earl parents
      steve.update(:spouse_id => lois.id)
      lois.update(:spouse_id => steve.id)
      #mary parents
      gary.update(:spouse_id => beth.id)
      beth.update(:spouse_id => gary.id)

      gary.grandchildren.should eq [karl]
    end
  end
  describe '#siblings' do
    it 'displays siblings' do
      karl = Person.create(:name => 'Karl')
      lizzie = Person.create(:name => 'Lizzie')
      #karl parents
      earl = Person.create(:name => 'Earl')
      mary = Person.create(:name => 'Mary')
      karl.update({:father_id => earl.id, :mother_id => mary.id})
      lizzie.update({:father_id => earl.id, :mother_id => mary.id})
      #karl parents
      earl.update({:spouse_id => mary.id})
      mary.update(:spouse_id => earl.id)
      karl.siblings.should eq [lizzie]
    end
  end

  describe '#cousins' do
    it 'returns the cousins of a person' do
      karl = Person.create(:name => 'Karl')
      #karl parents
      earl = Person.create(:name => 'Earl')
      mary = Person.create(:name => 'Mary')
      #earl brothers
      phil = Person.create(:name => 'Phil')
      tommy = Person.create(:name => 'Tommy')
      #phil wife
      wife = Person.create(:name => 'Wife Lady')
      #earl parents
      steve = Person.create(:name => 'Steve')
      lois = Person.create(:name => 'Lois')

      #karl cousins
      maggie = Person.create(:name => 'Maggie')
      glen = Person.create(:name => 'Glen')
      #mary parents
      gary = Person.create(:name => 'Gary')
      beth = Person.create(:name => 'Beth')

      karl.update({:father_id => earl.id, :mother_id => mary.id})
      #karl parents
      earl.update({:spouse_id => mary.id, :father_id => steve.id, :mother_id => lois.id})
      mary.update(:spouse_id => earl.id, :father_id => gary.id, :mother_id => beth.id)
      #earl brothers
      phil.update({:father_id => steve.id, :mother_id => lois.id})
      tommy.update({:father_id => steve.id, :mother_id => lois.id})
      #karl cousins
      maggie.update({:father_id => phil.id, :mother_id => wife.id})
      glen.update({:father_id => tommy.id, :mother_id => wife.id})
      #earl parents
      steve.update(:spouse_id => lois.id)
      lois.update(:spouse_id => steve.id)
      karl.cousins.should eq [maggie, glen]
    end
  end
  describe '#aunts_uncles' do
    it 'returns the aunts and uncles of a person' do
      karl = Person.create(:name => 'Karl')
      #karl parents
      earl = Person.create(:name => 'Earl')
      mary = Person.create(:name => 'Mary')
      #earl brothers
      phil = Person.create(:name => 'Phil')
      tommy = Person.create(:name => 'Tommy')
      #phil wife
      wife = Person.create(:name => 'Wife Lady')
      #earl parents
      steve = Person.create(:name => 'Steve')
      lois = Person.create(:name => 'Lois')

      #karl cousins
      maggie = Person.create(:name => 'Maggie')
      glen = Person.create(:name => 'Glen')
      #mary parents
      gary = Person.create(:name => 'Gary')
      beth = Person.create(:name => 'Beth')

      karl.update({:father_id => earl.id, :mother_id => mary.id})
      #karl parents
      earl.update({:spouse_id => mary.id, :father_id => steve.id, :mother_id => lois.id})
      mary.update(:spouse_id => earl.id, :father_id => gary.id, :mother_id => beth.id)
      #earl brothers
      phil.update({:father_id => steve.id, :mother_id => lois.id})
      tommy.update({:father_id => steve.id, :mother_id => lois.id})
      #karl cousins
      maggie.update({:father_id => phil.id, :mother_id => wife.id})
      glen.update({:father_id => tommy.id, :mother_id => wife.id})
      #earl parents
      steve.update(:spouse_id => lois.id)
      lois.update(:spouse_id => steve.id)
      karl.aunts_uncles.should eq [phil, tommy]
    end
  end
end
