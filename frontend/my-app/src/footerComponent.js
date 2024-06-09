import React from "react";
import { Box, Typography, Container } from "@mui/material";

const FooterComponent = ({ testMessage }) => {
  return (
    <Box
      component="footer"
      sx={{
        py: 2,
        backgroundColor: (theme) =>
          theme.palette.mode === 'light' ? theme.palette.grey[200] : theme.palette.grey[800],
        textAlign: 'center',
        width: '100%',
      }}
    >
      <Container maxWidth="lg">
        <Typography variant="body1">Test Message from Server : {testMessage}</Typography>
      </Container>
    </Box>
  );
};

export default FooterComponent;
