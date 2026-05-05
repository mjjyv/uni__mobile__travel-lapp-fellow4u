const { Location, Attraction, Country, Tour, Experience } = require('../models');

exports.getLocationDetail = async (req, res) => {
  try {
    const { id } = req.params;
    const location = await Location.findByPk(id, {
      include: [
        { model: Country },
        { model: Attraction, as: 'Attractions' },
        { model: Tour, limit: 5 },
        { model: Experience, limit: 5 }
      ]
    });

    if (!location) {
      return res.status(404).json({ message: 'Location not found' });
    }

    res.status(200).json(location);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching location detail', error: error.message });
  }
};
