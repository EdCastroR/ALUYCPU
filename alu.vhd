library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Port (
        -- Entradas
        A : in STD_LOGIC_VECTOR(7 downto 0);
        B : in STD_LOGIC_VECTOR(7 downto 0);
        ALU_Sel : in STD_LOGIC_VECTOR(1 downto 0); 
		  
        -- Salidas
        Result : buffer STD_LOGIC_VECTOR(7 downto 0); 
        NZVC : out STD_LOGIC_VECTOR(3 downto 0)
    );
end alu;

architecture alu_arch of alu is
begin
    ALU_PROCESS : process (A, B, ALU_Sel)
        variable Sum_uns : unsigned(8 downto 0);
    begin
		  --SUMA
        if (ALU_Sel = "00") then
		  
            -- Para Cálculo de la suma
            Sum_uns := unsigned('0' & A) + unsigned('0' & B);
            Result <= std_logic_vector(Sum_uns(7 downto 0));
            
            -- Banderas de estado
            -- Bandera Negativa (N)
            NZVC(3) <= Sum_uns(7);
            
            -- Bandera Zero (Z)
            if (Sum_uns(7 downto 0) = x"00") then
                NZVC(2) <= '1';
            else
                NZVC(2) <= '0';
            end if;
            
            -- Bandera de Overflow (V)
            if ((A(7)='0' and B(7)='0' and Sum_uns(7)='1') or (A(7)='1' and B(7)='1' and Sum_uns(7)='0')) then
                NZVC(1) <= '1';
            else
                NZVC(1) <= '0';
            end if;
            
            -- Bandera de Carry (C)
            NZVC(0) <= Sum_uns(8);
            
				-- RESTA
        elsif (ALU_Sel = "01") then
		  
            -- Cálculo de la resta
            Sum_uns := unsigned('0' & A) - unsigned('0' & B);
            Result <= std_logic_vector(Sum_uns(7 downto 0));
            
            -- Banderas de estado
				-- Bandera Negativa (N)
            NZVC(3) <= Sum_uns(7);
            
            -- Bandera Zero (Z)
            if (Sum_uns(7 downto 0) = x"00") then
                NZVC(2) <= '1';
            else
                NZVC(2) <= '0';
            end if;
            
            -- Bandera de Overflow (V)
            if ((A(7)='0' and B(7)='1' and Sum_uns(7)='1') or (A(7)='1' and B(7)='0' and Sum_uns(7)='0')) then
                NZVC(1) <= '1';
            else
                NZVC(1) <= '0';
            end if;
            
            -- Bandera de Carry (C)
            if unsigned(A) < unsigned(B) then
                NZVC(0) <= '1';
            else
                NZVC(0) <= '0';
            end if;
        elsif (ALU_Sel = "10") then -- AND
           
            Result <= A and B;
            
            -- Banderas de estado
				-- Bandera Negativa (N)
            NZVC(3) <= Result(7);
            
            -- Bandera Zero (Z)
            if (Result = x"00") then
                NZVC(2) <= '1';
            else
                NZVC(2) <= '0';
            end if;
            
            -- Bandera de Overflow (V)
            NZVC(1) <= '0';
            
            -- Bandera de Carry (C)
            NZVC(0) <= '0';
            
        elsif (ALU_Sel = "11") then -- OR
            
            Result <= A or B;
            
            -- Banderas de estado
				-- Bandera Negativa (N)
            NZVC(3) <= Result(7);
            
            -- Bandera Zero (Z)
            if (Result = x"00") then
                NZVC(2) <= '1';
            else
                NZVC(2) <= '0';
            end if;
            
            -- Bandera de Overflow (V)
            NZVC(1) <= '0';
            
            -- Bandera de Carry (C)	
            NZVC(0) <= '0';
        end if;
    end process;
end alu_arch;
