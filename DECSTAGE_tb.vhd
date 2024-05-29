LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY DECSTAGE_tb IS
END;

ARCHITECTURE bench OF DECSTAGE_tb IS

  COMPONENT DECSTAGE
    PORT (
      Instr         : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
      RF_WrEn       : IN  STD_LOGIC;
      ALU_out       : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
      MEM_out       : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
      RF_WrData_sel : IN  STD_LOGIC;
      RF_B_sel      : IN  STD_LOGIC;
      Clk           : IN  STD_LOGIC;
      Reset_regs    : IN  STD_LOGIC;
      Sel_immed     : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
      Immed         : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      RF_A          : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      RF_B          : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL Instr         : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL RF_WrEn       : STD_LOGIC;
  SIGNAL ALU_out       : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL MEM_out       : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL RF_WrData_sel : STD_LOGIC;
  SIGNAL RF_B_sel      : STD_LOGIC;
  SIGNAL Clk           : STD_LOGIC;
  SIGNAL Reset_regs    : STD_LOGIC;
  SIGNAL Sel_immed     : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL Immed         : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL RF_A          : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL RF_B          : STD_LOGIC_VECTOR (31 DOWNTO 0);
  -- Clock period definitions
  CONSTANT Clk_period  : TIME := 10 ns;

BEGIN
  uut : DECSTAGE PORT MAP(
    Instr         => Instr,
    RF_WrEn       => RF_WrEn,
    ALU_out       => ALU_out,
    MEM_out       => MEM_out,
    RF_WrData_sel => RF_WrData_sel,
    RF_B_sel      => RF_B_sel,
    Clk           => Clk,
    Reset_regs    => Reset_regs,
    Sel_immed     => Sel_immed,
    Immed         => Immed,
    RF_A          => RF_A,
    RF_B          => RF_B);

  -- Clock process definitions
  Clk_process : PROCESS
  BEGIN
    Clk <= '0';
    WAIT FOR Clk_period/2;
    Clk <= '1';
    WAIT FOR Clk_period/2;
  END PROCESS;

  stimulus : PROCESS
  BEGIN
    --reset registers
    Reset_regs <= '1';
    WAIT FOR Clk_period;

    
    Reset_regs    <= '0';
    -- constructing an R-Type instruction
    -- output regs are r1 and r31
    -- write MEM_out in r1
    -- we expect MEM_out in Output1 = r1 and all zeros in Output2 = r31
    Instr         <= "000000" & "00001" & "00001" & "01111" & "00000000000";
    RF_WrEn       <= '1';
    ALU_out       <= "00000001110111111000001000000011";
    MEM_out       <= "11000001110111111000001000000011";
    RF_WrData_sel <= '1';  -- MEM_out
    RF_B_sel      <= '0';  -- due to R-Type/ read from Ard2 = Rt
    Sel_immed     <= "00"; -- don't care

    
    WAIT FOR Clk_period;

    
    Reset_regs    <= '0';
    -- constructing an R-Type instruction (to see
    --    if we can write data in r0 which is illegal
    -- output regs are r0 and r31
    -- write MEM_out in r0
    -- we DON'T expect MEM_out, but all zeros, in Output1 = r0 and Output2 = r31
    Instr         <= "000000" & "00000" & "00000" & "01111" & "00000000000";
    RF_WrEn       <= '1';
    ALU_out       <= "00000001110111111000001000000011";
    MEM_out       <= "11000001110111111000001000000011";
    RF_WrData_sel <= '1';  -- MEM_out
    RF_B_sel      <= '0';  -- due to R-Type/ read from Ard2 = Rt
    Sel_immed     <= "00"; -- don't care
    WAIT FOR Clk_period;

    
    Reset_regs    <= '0';
    -- constructing an I-Type instruction
    -- output regs are r1 and r31
    -- write ALU_out in r1
    -- we expect ALU_out in Output1 = r1 and all zeros in Output2 = r31
    -- we expect sign extended Immediate in output
    Instr         <= "000000" & "00001" & "00001" & "1011001001110011";
    RF_WrEn       <= '1';
    ALU_out       <= "00000001110111111000001000000011";
    MEM_out       <= "11000001110111111000001000000011";
    RF_WrData_sel <= '0';  -- ALU_out
    RF_B_sel      <= '0';  -- don't care
    Sel_immed     <= "10"; -- DON'T shift and sign extend
    WAIT FOR Clk_period;

    
    Reset_regs    <= '0';
    -- constructing an I-Type instruction
    -- output regs are r1 and r31
    -- write ALU_out in r1
    -- we expect ALU_out in Output1 = r1 and all zeros in Output2 = r31
    -- we expect zero filled Immediate in output
    Instr         <= "000000" & "00001" & "00001" & "1011001001110011";
    RF_WrEn       <= '1';
    ALU_out       <= "00000001110111111000001000000011";
    MEM_out       <= "11000001110111111000001000000011";
    RF_WrData_sel <= '0';  -- ALU_out
    RF_B_sel      <= '0';  -- don't care
    Sel_immed     <= "11"; -- DONT shift and ZEROFILL
    WAIT;
  END PROCESS;
END;
