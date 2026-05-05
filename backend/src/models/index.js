const sequelize = require('../config/database');
const User = require('./User');
const Country = require('./Country');
const SocialAccount = require('./SocialAccount');
const PasswordReset = require('./PasswordReset');
const Location = require('./Location');
const GuideProfile = require('./GuideProfile');
const Tour = require('./Tour');
const Experience = require('./Experience');
const TravelNews = require('./TravelNews');
const Wishlist = require('./Wishlist');
const Language = require('./Language');
const GuidePricing = require('./GuidePricing');
const Review = require('./Review');
const Attraction = require('./Attraction');
const PortfolioMedia = require('./PortfolioMedia');

// Associations - Module 1
User.belongsTo(Country, { foreignKey: 'country_id' });
Country.hasMany(User, { foreignKey: 'country_id' });

User.hasMany(SocialAccount, { foreignKey: 'user_id' });
SocialAccount.belongsTo(User, { foreignKey: 'user_id' });

// Associations - Module 2
Location.belongsTo(Country, { foreignKey: 'country_id' });
Country.hasMany(Location, { foreignKey: 'country_id' });

User.hasOne(GuideProfile, { foreignKey: 'guide_id' });
GuideProfile.belongsTo(User, { foreignKey: 'guide_id' });

GuideProfile.belongsTo(Location, { foreignKey: 'base_location_id', as: 'BaseLocation' });

Tour.belongsTo(Location, { foreignKey: 'location_id' });
Location.hasMany(Tour, { foreignKey: 'location_id' });

Experience.belongsTo(GuideProfile, { foreignKey: 'guide_id' });
GuideProfile.hasMany(Experience, { foreignKey: 'guide_id' });

Experience.belongsTo(Location, { foreignKey: 'location_id' });
Location.hasMany(Experience, { foreignKey: 'location_id' });

Wishlist.belongsTo(User, { foreignKey: 'user_id' });
Wishlist.belongsTo(Tour, { foreignKey: 'tour_id' });
Wishlist.belongsTo(Experience, { foreignKey: 'exp_id' });

// Associations - Module 3 (Service & Destination Detail)
GuideProfile.hasMany(GuidePricing, { foreignKey: 'guide_id', as: 'Pricings' });
GuidePricing.belongsTo(GuideProfile, { foreignKey: 'guide_id' });

GuideProfile.hasMany(Review, { foreignKey: 'guide_id', as: 'Reviews' });
Review.belongsTo(GuideProfile, { foreignKey: 'guide_id' });
Review.belongsTo(User, { foreignKey: 'author_id', as: 'Author' });

GuideProfile.hasMany(PortfolioMedia, { foreignKey: 'guide_id', as: 'Portfolio' });
PortfolioMedia.belongsTo(GuideProfile, { foreignKey: 'guide_id' });

GuideProfile.belongsToMany(Language, { 
  through: 'guide_languages', 
  foreignKey: 'guide_id', 
  otherKey: 'lang_id',
  timestamps: false 
});
Language.belongsToMany(GuideProfile, { 
  through: 'guide_languages', 
  foreignKey: 'lang_id', 
  otherKey: 'guide_id',
  timestamps: false 
});

Location.hasMany(Attraction, { foreignKey: 'location_id', as: 'Attractions' });
Attraction.belongsTo(Location, { foreignKey: 'location_id' });

module.exports = {
  sequelize,
  User,
  Country,
  SocialAccount,
  PasswordReset,
  Location,
  GuideProfile,
  Tour,
  Experience,
  TravelNews,
  Wishlist,
  Language,
  GuidePricing,
  Review,
  Attraction,
  PortfolioMedia
};
