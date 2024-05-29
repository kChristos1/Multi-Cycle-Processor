LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.array_pack.ALL;

ENTITY reg_file_tb IS
END reg_file_tb;

ARCHITECTURE behavior OF reg_file_tb IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT reg_file
        PORT (
            Ard1            : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            Ard2            : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            Awr             : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            Dout1           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Dout2           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Din             : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            WrEn            : IN  STD_LOGIC;
            Clk             : IN  STD_LOGIC;
            reset_registers : IN  STD_LOGIC
        );
    END COMPONENT;
    --Inputs
    SIGNAL Ard1            : STD_LOGIC_VECTOR(4 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL Ard2            : STD_LOGIC_VECTOR(4 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL Awr             : STD_LOGIC_VECTOR(4 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL Din             : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL WrEn            : STD_LOGIC                     := '0';
    SIGNAL Clk             : STD_LOGIC                     := '0';
    SIGNAL reset_registers : STD_LOGIC                     := '0';
    --Outputs
    SIGNAL Dout1           : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Dout2           : STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- Clock period definitions
    CONSTANT Clk_period    : TIME := 10 ns;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : reg_file PORT MAP(
        Ard1            => Ard1,
        Ard2            => Ard2,
        Awr             => Awr,
        Dout1           => Dout1,
        Dout2           => Dout2,
        Din             => Din,
        WrEn            => WrEn,
        Clk             => Clk,
        reset_registers => reset_registers
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
        -- insert stimulus here
        reset_registers <= '1';
        WAIT FOR Clk_period;

        reset_registers <= '0';
        WrEn            <= '1';
        Ard1            <= "00001";
        Ard2            <= "01111";

        --initialize registers r1 and r31.
        Din             <= "00000001110111111000001000000011";
        Awr             <= "00001";
        WAIT FOR Clk_period;

        Din <= "10000001110111111000001000000011";
        Awr <= "01111";
        WAIT FOR Clk_period;

        Din <= "11111111111111111111111111111111";
        Awr <= "00000";
        WAIT FOR Clk_period;
        
        Ard1 <= "00000";
        WAIT;
    END PROCESS;
END;
