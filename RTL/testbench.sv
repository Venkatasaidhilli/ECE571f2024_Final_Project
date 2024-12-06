`timescale 1ns / 1ps
import i2c_pkg::*;
module i2c_top_tb;

logic clk = 0, rst = 0, newd = 0, op;
logic [6:0] addr;
logic [7:0] din;
logic [7:0] dout;
logic busy,ack_err;
logic done;
i2c_top dut (.clk(clk),.rst(rst), .newd(newd), .op(op), .addr(addr), 
  .din(din), .dout(dout), .busy(busy), .ack_err(ack_err), .done(done));

always #5 clk = ~clk;


         //////single Read and write operation
// Task for Write Operation
  task automatic write_to_address(
    input logic [6:0] t_addr,    // Address to write to
    input logic [7:0] t_din      // Data to write
  );
    begin
      addr = t_addr;
      din = t_din;
      op = 0;                  // Write operation
      newd = 1;                // Start the transaction
      @(posedge clk);          // Wait for a clock edge
      newd = 0;                // Deassert newd after a clock cycle
      @(posedge done);         // Wait for the transaction to complete
      $display("[WRITE] Addr: %0h, Data: %0h", addr, din);
    end
  endtask

  // Task for Read Operation
  task automatic read_from_address(
    input logic [6:0] t_addr    // Address to read from
  );
    begin
      addr = t_addr;
      op = 1;                  // Read operation
      newd = 1;                // Start the transaction
      @(posedge clk);          // Wait for a clock edge
      newd = 0;                // Deassert newd after a clock cycle
      @(posedge done);         // Wait for the transaction to complete
      $display("[READ] Addr: %0h, Data: %0h", addr, dout);
    end
  endtask

  // Test Sequence
  initial begin
    // Reset sequence
    rst = 1;
    #10 rst = 0;

    // Write and Read test cases
    write_to_address(7'h5A, 8'h3C); // Write 0x3C to address 0x5A
    read_from_address(7'h5A);       // Read from address 0x5A

    // End simulation
    #50;
    //$stop;
  end


    ///////importing a package for writing data to a particular location
 initial begin 
    // Reset Sequence
    rst = 1;
    repeat (5) @(posedge clk);
    rst = 0;
    repeat (10) @(posedge clk);

    // Write to Slave
    addr = 7'h10;    // Example address
    din = 8'hAA;     // Example data
    write_to_slave(addr, din, newd, op);
    @(posedge done); // Wait for write completion
    newd = 0;        // Deassert new data
    $display("[TEST] Write operation complete.");

    // Simulation End
    repeat (10) @(posedge clk);
  end



           //////////////Random data write to random address and read from random address
initial begin  
rst = 1;
repeat(5) @(posedge clk);
rst = 0;
repeat(40) @(posedge clk);
//////////// write operation

for(int i = 0; i < 10 ; i++)
begin
newd = 1;
op = 0;
addr = $urandom_range(1,4);
din  =  $urandom_range(1,5);
  repeat(5) @(posedge clk);
  newd <= 1'b0;
@(posedge done);
$display("[WR] din : %0d addr: %0d",din, addr);
@(posedge clk);

end

////////////read operation

for(int i = 0; i < 10 ; i++)
begin
newd = 1;
op = 1;
addr = $urandom_range(1,4);
din = 0;
  repeat(5) @(posedge clk);
  newd <= 1'b0;  
@(posedge done);
$display("[RD] dout : %0d addr: %0d",dout, addr);
@(posedge clk);
end

repeat(10) @(posedge clk);
$stop;
end

endmodule
