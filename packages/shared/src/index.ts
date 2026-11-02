export const STATUS_RESULTADO = [ 'sucesso', 'lento', 'falha' ] as const;

// A lista precisa estar igual ao 'chk_status_valido' do banco
export type StatusResultado = typeof STATUS_RESULTADO[number];