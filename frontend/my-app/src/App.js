import React, { useEffect, useState } from "react";
import axios from "axios";
import { AgGridReact } from "ag-grid-react";
import "ag-grid-community/styles/ag-grid.css";
import "ag-grid-community/styles/ag-theme-quartz.css";
import "./App.css";
import ReactECharts from "echarts-for-react";

function App() {
  const [testMessage, setTestMessage] = useState("");
  const [errorMessage, setErrorMessage] = useState(null);
  const [rowData, setRowData] = useState([]);
  const [userCount, setBarData] = useState([]);

  const [columnDefs] = useState([
    { field: "name", headerName: "User Name" },
    { field: "registered_date", headerName: "Registered Date" },
    { field: "created_at", headerName: "Creation Date" },
    { field: "phone_number", headerName: "Phone Number" },
  ]);

  const barOptions = {
    tooltip: {
      trigger: "axis",
    },
    title: {
      text: "User Registrations Per Year",
      textStyle: {
        align: "center",
      },
    },
    xAxis: {
      type: "category",
      data: userCount.map((item) => item.Year),
    },
    yAxis: {
      type: "value",
    },
    series: [
      {
        data: userCount.map((item) => item.countOfUsers),
        type: "bar",
        animationDelay: (idx) => idx * 100, 
        animationDuration: 1000, 
        animationEasing: "elasticOut", 
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: "rgba(0, 0, 0, 0.5)",
          },
        },
      },
    ],
    dataZoom: [
      {
        type: "inside",
        start: 0,
        end: 100,
        zoomOnMouseWheel: true,
        moveOnMouseMove: true,
        preventDefaultMouseMove: false,
      },
    ],
    animationEasing: "elasticOut", // Easing function for the overall animation
    animationDelayUpdate: (idx) => idx * 50, // Delay animation for each bar when updating
  };

  useEffect(() => {
    fetchUsers();
    fetchTest();
    getUserCountPerYear();
    const interval1 = setInterval(fetchUsers, 10000);
    const interval2 = setInterval(fetchTest, 10000);
    const interval3 = setInterval(getUserCountPerYear, 10000);

    return () => {
      clearInterval(interval1);
      clearInterval(interval2);
      clearInterval(interval3);
    };
  }, []);

  const fetchUsers = async () => {
    try {
      console.log("Fetching users");
      const response = await axios.get("http://127.0.0.1:1000/api/users");
      console.log("Response:", response);

      const reversedData = response.data.reverse();
      setRowData(reversedData);
    } catch (error) {
      console.error("Error fetching users:", error);
      setErrorMessage("Error fetching users. Please try again later.");
    }
  };

  const getUserCountPerYear = async () => {
    try {
      console.log("Fetching users");
      const response = await axios.get("http://127.0.0.1:1000/api/user-count");
      console.log("Response:", response);
      setBarData(response.data);
    } catch (error) {
      console.error("Error fetching users:", error);
      setErrorMessage("Error fetching users. Please try again later.");
    }
  };

  const fetchTest = async () => {
    try {
      const response = await axios.get("http://127.0.0.1:1000/api/test");
      setTestMessage(response.data);
    } catch (error) {
      console.error("Error fetching test message:", error);
      setErrorMessage("Error fetching test message. Please try again later.");
    }
  };

  return (
    <div className="user-info">
      <h1>Random User Info</h1>
      <p>UI request Data every 10 seconds to the server</p>
      <p>Server retrieves data from a postgres Database</p>
      <p>
        Data Source -API :{" "}
        <a href="https://randomuser.me/api/">Random User API</a>
      </p>
      <div style={{ height: "300px", width: "100%" }}>
        <ReactECharts option={barOptions} />
      </div>
      <div className="ag-theme-quartz" style={{ height: 600, width: "100%" }}>
        <AgGridReact
          rowData={rowData}
          columnDefs={columnDefs}
          pagination={true}
          paginationPageSize={10}
        />
      </div>

      <h1>Test Message</h1>
      <p>{testMessage}</p>
    </div>
  );
}

export default App;
