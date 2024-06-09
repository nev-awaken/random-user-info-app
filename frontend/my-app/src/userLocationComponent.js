// src/userLocationComponent.js

import React from 'react';
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';

const MapComponent = ({ countryData }) => {
  return (
    <MapContainer style={{ height: '100%', width: '100%' }} center={[51.505, -0.09]} zoom={2}>
      <TileLayer
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        attribution='&copy; <a href="https://osm.org/copyright">OpenStreetMap</a> contributors'
      />
      {countryData.map((country, idx) => (
        <Marker key={idx} position={[country.latitude, country.longitude]}>
          <Popup>
            {country.name}: {country.userCount}
          </Popup>
        </Marker>
      ))}
    </MapContainer>
  );
};

export default MapComponent;
