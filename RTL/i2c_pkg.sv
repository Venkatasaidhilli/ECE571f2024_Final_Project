package i2c_pkg;

  // Task to write data to a specific address in slave
  task automatic write_to_slave(
    input logic [6:0] addr,
    input logic [7:0] data,
    output logic newd,
    output logic op
  );
    begin
      newd = 1'b1; // Indicate new data
      op = 1'b0;   // Write operation
      $display("[INFO] Writing data %0d to address %0d", data, addr);
    end
  endtask

endpackage : i2c_pkg

