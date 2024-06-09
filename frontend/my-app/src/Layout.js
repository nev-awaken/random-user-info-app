// src/Layout.js

import React from 'react';
import { AppBar, Toolbar, Typography, Container} from '@mui/material';

const Layout = ({ children }) => {
  return (
    <>
      <AppBar position="static">
        <Toolbar>
          <Typography variant="h6">
            Random User Info
          </Typography>
        </Toolbar>
      </AppBar>
      <Container maxWidth="lg">
        {children}
      </Container>
    </>
  );
};

export default Layout;
