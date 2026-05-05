const { Tour, Experience, Location, GuideProfile, User, Review, TourProvider, TourImage, TourSchedule, TourAgePricing, Attraction } = require('../models');

exports.getTourDetail = async (req, res) => {
  try {
    const { id } = req.params;
    const tour = await Tour.findByPk(id, {
      include: [
        { model: Location },
        { model: TourProvider, as: 'Provider' },
        { model: TourImage, as: 'Images' },
        { 
          model: TourSchedule, 
          as: 'Schedules',
          include: [{ model: Attraction }]
        },
        { model: TourAgePricing, as: 'AgePricings' }
      ]
    });

    if (!tour) {
      return res.status(404).json({ message: 'Tour not found' });
    }

    res.status(200).json(tour);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching tour detail', error: error.message });
  }
};

exports.getExperienceDetail = async (req, res) => {
  try {
    const { id } = req.params;
    const experience = await Experience.findByPk(id, {
      include: [
        { model: Location },
        { 
          model: GuideProfile,
          include: [{ model: User, attributes: ['first_name', 'last_name', 'avatar_url'] }]
        }
      ]
    });

    if (!experience) {
      return res.status(404).json({ message: 'Experience not found' });
    }

    res.status(200).json(experience);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching experience detail', error: error.message });
  }
};
