class User < ApplicationRecord
  #テストデータ挿入
  after_create :seed_initial_data

  # devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # 語彙、文章
  has_many :vocabularies, dependent: :destroy
  has_many :sentences, dependent: :destroy
  # タグ
  has_many :sentence_tags, dependent: :destroy
  has_many :vocabulary_tags, dependent: :destroy
  # bookmark
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_vocabularies, through: :bookmarks, source: :bookmarkable, source_type: "Vocabulary"
  has_many :bookmark_sentences, through: :bookmarks, source: :bookmarkable, source_type: "Sentence"


  # 保存前に入力を整形する(前後スペース削除・メールを小文字化)
  before_validation :normalize

  # メール：必須・一意・形式チェック / ログインに使用
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  # 名前：必須・一意・長さチェック
  validates :name, presence: true, uniqueness: true,
                    length: { in: 3..30 }
  # パスワード：必須・長さチェック・確認入力チェック (新規登録時と変更時のみ)
  validates :password, length: { minimum: 8 },
                       confirmation: true,
                       if: -> { new_record? || changes[:crypted_password] }

  private
  # 入力の整形を行うメソッド / 前後の空白行を削除し、メールアドレスは小文字化
  def normalize
    self.email = email.to_s.strip.downcase
    self.name  = name.to_s.strip
  end

  def seed_initial_data
    if ENV['SEED_ON_SIGNUP'] == 'true'
      Rails.logger.info "=== [seed] start user=#{email}"
      UserSignupSeeder.run(self)
      Rails.logger.info "=== [seed] done  user=#{email}"
    else
      Rails.logger.info "=== [seed] skip  user=#{email} (flag off)"
    end
  end

end
