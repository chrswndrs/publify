require 'spec_helper'

describe Admin::TagsController do
  render_views
  
  before do
    Factory(:blog)
    request.session = { :user => users(:tobi).id }
  end

  describe 'index action' do
    before :each do
      get :index
    end

    it 'should be success' do
      response.should be_success
    end

    it 'should render template index' do
      response.should render_template('index')
    end
    
    it 'should have Articles as selected tab only' do
      test_tabs "Articles"
    end
    
    it 'should have article, new article, comments, categories subtab links' do
      subtabs = ["Articles", "Add new", "Comments", "Categories", "Tags"]
      test_subtabs(subtabs, "Tags")
    end  
  end

  describe 'edit action' do
    before(:each) do
      tag_id = Factory(:tag).id
      get :edit, :id => tag_id
    end

    it 'should be success' do
      response.should be_success
    end

    it 'should render template edit' do
      response.should render_template('edit')
    end

    it 'should assigns value :tag' do
      assert assigns(:tag).valid?
    end
    
    it 'should have a link back to list' do
      response.should have_selector("ul#subtabs>li>a", :content => "Back to list")
    end
    
    it 'should have Articles as selected tab only' do
      test_tabs "Articles"
    end
  end
  
  describe 'destroy action with GET' do
    before(:each) do
      tag_id = Factory(:tag).id
      get :destroy, :id => tag_id
    end
    
    it 'should be success' do
      response.should be_success
    end

    it 'should render template edit' do
      response.should render_template('destroy')
    end

    it 'should assigns value :tag' do
      assert assigns(:tag).valid?
    end
    
    it 'should have a link back to list' do
      response.should have_selector("ul#subtabs>li>a", :content => "Back to list")
    end
    
    it 'should have Articles as selected tab only' do
      test_tabs "Articles"
    end
  end

  describe 'destroy action with POST' do
    before do
      @tag = Factory(:tag)
      post :destroy, 'id' => @tag.id, 'tag' => {:display_name => 'Foo Bar'}
    end
    
    it 'should redirect to index' do
      response.should redirect_to(:action => 'index')
    end
    
    it 'should have one less tags' do
      Tag.count.should == 0
    end
    
  end

  describe 'update action' do
    before do
      @tag = Factory(:tag)
      post :edit, 'id' => @tag.id, 'tag' => {:display_name => 'Foo Bar'}
    end

    it 'should redirect to index' do
      response.should redirect_to(:action => 'index')
    end

    it 'should update tag' do
      @tag.reload
      @tag.name.should == 'foo-bar'
      @tag.display_name.should == "Foo Bar"
    end

    it 'should create a redirect from the old to the new' do
      old_name = @tag.name
      @tag.reload
      new_name = @tag.name

      r = Redirect.find_by_from_path "/tag/#{old_name}"
      r.to_path.should == "/tag/#{new_name}"
    end
  end

end
