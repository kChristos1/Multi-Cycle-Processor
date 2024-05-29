LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY IFSTAGE_tb IS
END IFSTAGE_tb;

ARCHITECTURE behavior OF IFSTAGE_tb IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT IFSTAGE
        PORT (
            PC_Immed : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            PC_sel   : IN  STD_LOGIC;
            PC_LdEn  : IN  STD_LOGIC;
            Reset    : IN  STD_LOGIC;
            Clk      : IN  STD_LOGIC;
            Instr    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    --Inputs
    SIGNAL PC_Immed     : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL PC_sel       : STD_LOGIC                     := '0';
    SIGNAL PC_LdEn      : STD_LOGIC                     := '0';
    SIGNAL Reset        : STD_LOGIC                     := '0';
    SIGNAL Clk          : STD_LOGIC                     := '0';
    --Outputs
    SIGNAL Instr        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- Clock period definitions
    CONSTANT Clk_period : TIME := 10 ns;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : IFSTAGE PORT MAP(
        PC_Immed => PC_Immed,
        PC_sel   => PC_sel,
        PC_LdEn  => PC_LdEn,
        Reset    => Reset,
        Clk      => Clk,
        Instr    => Instr
    );
    -- Clock process definitions
    Clk_process : PROCESS
    BEGIN
        Clk <= '0';
        WAIT FOR Clk_period/2;
        Clk <= '1';
        WAIT FOR Clk_period/2;
    END PROCESS;
    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        --reset
        Reset <= '1';
        WAIT FOR Clk_period;

        Reset    <= '0';
        PC_Immed <= "00000000000000000000000011110001";
        PC_sel   <= '0';
        PC_LdEn  <= '1';
        WAIT FOR Clk_period;

        Reset    <= '0';
        PC_Immed <= "00000000000000000000000011110001";
        PC_sel   <= '0';
        PC_LdEn  <= '1';
        WAIT FOR Clk_period;

        Reset    <= '0';
        PC_Immed <= "00000000000000000000000000000100";
        PC_sel   <= '1';
        PC_LdEn  <= '1';
        WAIT;
    END PROCESS;
END;
