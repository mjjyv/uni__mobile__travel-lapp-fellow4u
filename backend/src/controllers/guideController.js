const { GuideProfile, User, Location, Language, GuidePricing, Review, PortfolioMedia } = require('../models');

exports.getGuideDetail = async (req, res) => {
  try {
    const { id } = req.params;
    const guide = await GuideProfile.findByPk(id, {
      include: [
        { 
          model: User, 
          attributes: ['first_name', 'last_name', 'avatar_url', 'bio', 'cover_url'] 
        },
        { model: Location, as: 'BaseLocation' },
        { model: Language, through: { attributes: [] } },
        { model: GuidePricing, as: 'Pricings' },
        { 
          model: Review, 
          as: 'Reviews',
          include: [{ model: User, as: 'Author', attributes: ['first_name', 'last_name', 'avatar_url'] }]
        },
        { model: PortfolioMedia, as: 'Portfolio' }
      ]
    });

    if (!guide) {
      return res.status(404).json({ message: 'Guide not found' });
    }

    res.status(200).json(guide);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching guide detail', error: error.message });
  }
};
