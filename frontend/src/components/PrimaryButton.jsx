import React from 'react';
import PropTypes from 'prop-types';

// Define the PrimaryButton component
const PrimaryButton = ({ text, onClick, disabled = false }) => {
  return (
    <button
      className="primary-button"
      onClick={onClick}
      disabled={disabled}
      style={{
        backgroundColor: '#007bff',
        color: '#fff',
        border: 'none',
        padding: '10px 20px',
        borderRadius: '5px',
        cursor: 'pointer',
        fontSize: '16px',
      }}
    >
      {text}
    </button>
  );
};

// Define prop types for the component
PrimaryButton.propTypes = {
  text: PropTypes.string.isRequired,
  onClick: PropTypes.func.isRequired,
  disabled: PropTypes.bool,
};

export default PrimaryButton; 