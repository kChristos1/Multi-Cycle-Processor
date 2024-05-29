LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY mux2to1_tb IS
END;

ARCHITECTURE bench OF mux2to1_tb IS
  COMPONENT mux2to1
    PORT (
      a      : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
      b      : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
      sele   : IN  STD_LOGIC;
      muxout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
  END COMPONENT;
  SIGNAL a      : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL b      : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL sele   : STD_LOGIC;
  SIGNAL muxout : STD_LOGIC_VECTOR (31 DOWNTO 0);
BEGIN
  uut : mux2to1 PORT MAP(
    a      => a,
    b      => b,
    sele   => sele,
    muxout => muxout);
  stimulus : PROCESS
  BEGIN
    a    <= x"00000000";
    b    <= x"00000011";

    sele <= '0';
    WAIT FOR 10 ns;

    sele <= '1';
    WAIT FOR 10 ns;


    a    <= x"11111111";
    b    <= x"00000000";

    sele <= '0';
    WAIT FOR 10 ns;
    
    sele <= '1';
    WAIT FOR 10 ns;
  END PROCESS;
END;
