LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux4_tb IS
END mux4_tb;

ARCHITECTURE behavior OF mux4_tb IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT mux4
        PORT (
            a      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            b      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            sele   : IN  STD_LOGIC;
            muxout : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
        );
    END COMPONENT;
    --Inputs
    SIGNAL a      : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL b      : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sele   : STD_LOGIC                    := '0';
    --Outputs
    SIGNAL muxout : STD_LOGIC_VECTOR(4 DOWNTO 0);
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : mux4 PORT MAP(
        a      => a,
        b      => b,
        sele   => sele,
        muxout => muxout
    );
    stimulus : PROCESS
    BEGIN
        a    <= "00000";
        b    <= "00001";

        sele <= '0';
        WAIT FOR 10 ns;

        sele <= '1';
        WAIT FOR 10 ns;


        a    <= "11111";
        b    <= "01011";

        sele <= '0';
        WAIT FOR 10 ns;
        
        sele <= '1';
        WAIT FOR 10 ns;
    END PROCESS;
END;
